require 'spec_helper'

class FooController < ApplicationController
  before_filter :authenticate!
  def index
    render :text => 'Hello world'
  end
end

describe FooController do
  context 'not logged in (outside canvas)' do
    before(:each) do
      session[:user_id] = 1
      User.should_receive(:find_by_id).with(1).and_return(nil)
      get :index
    end

    it 'should store the fb app url plus the path to return to' do
      session[:return_to].should == '/assets'
    end
    it { should redirect_to("/auth/facebook") }
  end

  context 'logged in' do
    before(:each) do
      session[:user_id] = 1
      user = double('user')
      User.should_receive(:find_by_id).with(1).and_return(user)
      get :index
    end

    it { should respond_with(:success) }
    it "should not halt" do
      response.body.should include('Hello world')
    end
  end
end
