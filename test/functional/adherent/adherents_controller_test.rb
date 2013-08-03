require 'test_helper'

module Adherent
  class AdherentsControllerTest < ActionController::TestCase
    setup do
      @adherent = adherents(:one)
    end
  
    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:adherents)
    end
  
    test "should get new" do
      get :new
      assert_response :success
    end
  
    test "should create adherent" do
      assert_difference('Adherent.count') do
        post :create, adherent: { birthdate: @adherent.birthdate, forname: @adherent.forname, name: @adherent.name, number: @adherent.number }
      end
  
      assert_redirected_to adherent_path(assigns(:adherent))
    end
  
    test "should show adherent" do
      get :show, id: @adherent
      assert_response :success
    end
  
    test "should get edit" do
      get :edit, id: @adherent
      assert_response :success
    end
  
    test "should update adherent" do
      put :update, id: @adherent, adherent: { birthdate: @adherent.birthdate, forname: @adherent.forname, name: @adherent.name, number: @adherent.number }
      assert_redirected_to adherent_path(assigns(:adherent))
    end
  
    test "should destroy adherent" do
      assert_difference('Adherent.count', -1) do
        delete :destroy, id: @adherent
      end
  
      assert_redirected_to adherents_path
    end
  end
end
