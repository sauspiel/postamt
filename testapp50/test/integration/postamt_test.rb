require 'test_helper'

class PostamtTest < ActionDispatch::IntegrationTest
  def username_for(model_klass)
    model_klass.connection.pool.spec.config[:username]
  end

  def transaction_open?(model_klass)
    model_klass.connection.transaction_open?
  end

  teardown do
    Bar.delete_all
    Foo.delete_all
  end

  test "self.default_connection" do
    assert_equal "master", username_for(Bar)
    assert_equal "slave", username_for(Foo)
  end

  test "Postamt.on(...) overwrites default_connection" do
    Postamt.on(:slave) do
      assert_equal "slave", username_for(Bar)
      assert_equal "slave", username_for(Foo)
    end

    Postamt.on(:master) do
      assert_equal "master", username_for(Bar)
      assert_equal "master", username_for(Foo)
    end
  end

  test "transaction overwrites default_connection" do
    assert_equal "master", username_for(Bar)
    assert_equal "slave", username_for(Foo)

    ActiveRecord::Base.transaction do
      assert_equal "master", username_for(Bar)
      assert_equal "master", username_for(Foo)
    end

    assert_equal "master", username_for(Bar)
    assert_equal "slave", username_for(Foo)
  end

  test "Postamt.on(..) overwrites transaction" do
    assert_equal "master", username_for(Bar)
    assert_equal "slave", username_for(Foo)

    ActiveRecord::Base.transaction do
      assert_equal "master", username_for(Bar)
      assert_equal "master", username_for(Foo)

      Postamt.on(:slave) do
        assert_equal "slave", username_for(Bar)
        assert_equal "slave", username_for(Foo)
      end

      assert_equal "master", username_for(Bar)
      assert_equal "master", username_for(Foo)
    end

    assert_equal "master", username_for(Bar)
    assert_equal "slave", username_for(Foo)
  end

  test "master and slave are actually different connections" do
    # We test this by checking if transaction isolation between master and slave works
    bar = nil

    ActiveRecord::Base.transaction do
      bar = Bar.create!(message: 'random')

      Postamt.on(:slave) do
        assert_nil Bar.where(id: bar.id).first
      end

      Postamt.on(:master) do
        assert_not_nil Bar.where(id: bar.id).first
      end

      assert transaction_open?(Bar) # still in transaction?
    end
    assert !transaction_open?(Bar) # outside transaction?

    # After the transaction commits Bar becomes visible on the slave too
    Postamt.on(:slave) do
      assert_not_nil Bar.where(id: bar.id).first
    end
  end

end
