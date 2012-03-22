require 'test_helper'

class VsControllerTest < ActionController::TestCase
  test "should get rodada" do
    get :rodada
    assert_response :success
  end

end
