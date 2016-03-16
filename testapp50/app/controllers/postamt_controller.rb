class PostamtController < ApplicationController
  use_db_connection(:slave, for: [Bar], only: [:slave])

  def slave
    render_connection
  end

  def master
    render_connection
  end

  def render_connection
    render plain: Postamt.overwritten_default_connections[Bar].to_s
  end
end
