require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  test "model attributes match the expected columns" do
    expected = ['id', 'slug', 'url', 'hits', 'client_ip']
    actual = Link.new.attributes.keys
    assert_equal(expected, actual)
  end

  test "#save sets the slug value based on the base-36 representation of ID" do
    assert_difference('Link.count', +1, 'Expected a new Link to be saved') do
      link = Link.new(url: 'http://foo.bar', client_ip: '255.255.255.255')
      link.save
      expected = link.id.to_s(36)
      actual = link.slug
      assert_equal(expected, actual, 'Expected slug to be the base-36 representation of ID')
    end
  end

  test "#create sets the slug value based on the base-36 representation of ID" do
    assert_difference('Link.count', +1, 'Expected a new Link to be created') do
      link = Link.create(url: 'http://foo.bar', client_ip: '255.255.255.255')
      expected = link.id.to_s(36)
      actual = link.slug
      assert_equal(expected, actual, 'Expected slug to be the base-36 representation of ID')
    end
  end

  test "#create with valid url value passes validation and results in a new instance" do
    link = Link.create(url: 'http://www.google.com/', client_ip: '255.255.255.255')
    assert(link.persisted?, 'Expected link to be saved successfully')
    assert(link.valid?, 'Expected link to be valid')
    assert_equal('http://www.google.com/', link.url, 'The link was unexpectedly changed')
  end

  test "incorrect url value fails validation and does not save" do
    link = Link.new(url: 'abc123', client_ip: '255.255.255.255')
    refute(link.valid?, 'Expected the link to be invalid')
    refute(link.save, 'Expected saving an invalid link to fail')

    expected = {url: ["is invalid"]}
    actual = link.errors.messages
    assert_equal(expected, actual, 'Error messages did not match expectations')
  end

  test "#create with valid IPv4 client_ip passes validation and results in new instance" do
    link = Link.create(url: 'http://www.google.com/', client_ip: '127.0.0.1')
    assert(link.valid?, 'Expected link to pass validation')
    assert(link.persisted?, 'Expected link to be saved')
    assert_equal('127.0.0.1', link.client_ip, 'client_ip was unexpectedly changed')
  end

  test "incorrect IPv4 client_ip value fails validation and does not save" do
    link = Link.new(url: 'http://foo.bar', client_ip: '500.600.300.900')
    refute(link.valid?, 'Expected the link to be invalid')
    refute(link.save, 'Expected saving an invalid link to fail')

    expected = {client_ip: ["is invalid"]}
    actual = link.errors.messages
    assert_equal(expected, actual, 'Error messages did not match expectations')
  end

  test "#create with valid full-length IPv6 client_ip passes validation and results in new instance" do
    link = Link.create(url: 'http://www.google.com/', client_ip: '2001:0db8:85a3:0042:1000:8a2e:0370:7334')
    assert(link.valid?, 'Expected link to pass validation')
    assert(link.persisted?, 'Expected link to be saved')
    assert_equal('2001:0db8:85a3:0042:1000:8a2e:0370:7334', link.client_ip, 'client_ip was unexpectedly changed')
  end

  test "#create with valid shortened IPv6 client_ip passes validation and results in new instance" do
    link = Link.create(url: 'http://www.google.com/', client_ip: '2001:0db8::0370:7334')
    assert(link.valid?, 'Expected link to pass validation')
    assert(link.persisted?, 'Expected link to be saved')
    assert_equal('2001:0db8::0370:7334', link.client_ip, 'client_ip was unexpectedly changed')
  end

  test "incorrect IPv6 client_ip value fails validation and does not save" do
    link = Link.new(url: 'http://foo.bar', client_ip: 'zhi:foobar:plus')
    refute(link.valid?, 'Expected the link to be invalid')
    refute(link.save, 'Expected saving an invalid link to fail')

    expected = {client_ip: ["is invalid"]}
    actual = link.errors.messages
    assert_equal(expected, actual, 'Error messages did not match expectations')
  end
end
