require 'test_helper'

class LinksControllerTest < ActionController::TestCase
  test "#index responds successfully with the correct template" do
    get :index
    assert_response(:success, 'A success response was expected')
    assert_template(:index, 'The index template was expected to be used')
  end

  test "#create generates a new instance for a valid link parameter" do
    link_params = {url: 'http://foo.bar'}
    assert_difference('Link.count', +1, 'A Link was suppose to be created') do
      post :create, link_params
    end
  end

  test "#create responds to a valid link successfully with the index view and the short link" do
    link_params = {url: 'http://foo.bar'}
    post :create, link_params
    assert_response(:success, 'A success response code was expected')
    assert_template(:index, 'The index template was expected to be used')
    assert_not_nil(assigns(:link), 'The link instance was not assigned to the view')
  end

  test "#create returns an instance with the client's IP address" do
    link_params = {url: 'http://foo.bar'}
    expected = @request.env['REMOTE_ADDR'] = '255.254.253.252'

    Link.destroy_all
    assert(Link.count == 0)
    post :create, link_params
    link = Link.first

    actual = link.client_ip
    assert_equal(expected, actual, 'The stored IP does not match the client IP')
  end

  test "#redirect responds to a valid slug with the expected redirection" do
    link = links(:one)
    get :redirect, slug: link.slug
    assert_response(:redirect, 'A redirection response code was expected')
    assert_redirected_to(link.url, 'Was expected to be redirected to the correct URL')
  end

  test "#redirect increments the hits counter for the existing link" do
    link = links(:one)
    get :redirect, slug: link.slug

    expected = link.hits + 1
    actual = Link.find_by_id(link.id).hits
    assert_equal(expected, actual, 'Expected the hits counter to be incremented')
  end

  test "#redirect raises a not-found error when called with a nonexistant slug" do
    Link.destroy_all
    assert(Link.count == 0, 'Expected the links collection to be empty first.')

    assert_raise(ActiveRecord::RecordNotFound, 'Expected a RecordNotFound error to be raised') do
      get :redirect, slug: 'foobar'
    end
  end
end
