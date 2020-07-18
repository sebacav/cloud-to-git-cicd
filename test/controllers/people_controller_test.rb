require 'test_helper'

class PeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person = people(:one)
  end

  test "GET /people should be success (2xx)" do
    get people_url, as: :json
    assert_response :success
  end

  test "GET /people should be array" do
    get people_url as: :json
    assert_kind_of Array, JSON.parse(response.body)
  end

  test "GET /people/:nationalId should show person if this exist" do
    get people_url(@person.nationalId), as: :json
    assert_response :ok
  end

  test "GET /people/:nationalId should return status 404 if person is not found" do
    get "/people/"+"17473704-5", as: :json
    assert_response :not_found
  end

  test "POST /people + json should create person" do
    assert_difference('Person.count') do
      post people_url, params: { person: { age: @person.age, lastName: @person.lastName, name: @person.name, nationalId: "88888888-9", originPlanet: @person.originPlanet, pictureUrl: @person.pictureUrl } }, as: :json
    end
    assert_response :created
  end

  test "POST /people + json should return status 400 on validation error or when “Content-Type” header is not set as “application/json”" do
    post people_url, headers: { 'Content-Type' => 'text/plain' }, params: { person: { age: @person.age, lastName: @person.lastName, name: @person.name, nationalId: @person.nationalId, originPlanet: @person.originPlanet, pictureUrl: @person.pictureUrl } }, as: :json
    assert_response :bad_request
    post people_url
    assert_response :bad_request
  end

  test "PUT /people/:id + json should update person" do
    put "/people/"+@person.nationalId, params: { person: { age: @person.age, lastName: @person.lastName, name: @person.name, nationalId: @person.nationalId, originPlanet: @person.originPlanet, pictureUrl: @person.pictureUrl } }, as: :json
    assert_response :ok
  end

  test "PUT /people/:id + json should return status 404 if person is not found" do
    put "/people/"+"17473704-5", params: { person: { age: @person.age, lastName: @person.lastName, name: @person.name, nationalId: @person.nationalId, originPlanet: @person.originPlanet, pictureUrl: @person.pictureUrl } }, as: :json
    assert_response :not_found
  end

  test "PUT /people/:id + json should return status 400 on validation error or when “Content-Type” header is not set as “application/json”" do
    put "/people/"+@person.nationalId, headers: { 'Content-Type' => 'text/plain' }, params: { person: { age: @person.age, lastName: @person.lastName, name: @person.name, nationalId: @person.nationalId, originPlanet: @person.originPlanet, pictureUrl: @person.pictureUrl } }, as: :json
    assert_response :bad_request
    put "/people/"+@person.nationalId
    assert_response :bad_request
  end

  test "DELETE /people/:id should destroy a person and return status 200" do
    assert_difference('Person.count', -1) do
      delete "/people/"+@person.nationalId
    end
    assert_response :ok
  end

  test "DELETE /people/:id should return status 404 if person doesn't exist" do
    delete "/people/"+"17473704-5"
    assert_response :not_found
  end
end
