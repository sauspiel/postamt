require 'test_helper'

class PostamtControllerTest < ActionController::TestCase
  test "allows overriding the connection at the controller level" do
    get :slave
    assert_equal "slave", response.body
    assert_equal Postamt.overwritten_default_connections, {}
    get :master
    assert_equal "", response.body
  end
end
