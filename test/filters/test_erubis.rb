# encoding: utf-8

require 'helper'

class Nanoc::Erubis::FilterTest < Minitest::Test

  def test_filter_with_instance_variable
    # Create filter
    filter = ::Nanoc::Erubis::Filter.new({ :location => 'a cheap motel' })

    # Run filter
    result = filter.run('<%= "I was hiding in #{@location}." %>')
    assert_equal('I was hiding in a cheap motel.', result)
  end

  def test_filter_with_instance_method
    # Create filter
    filter = ::Nanoc::Erubis::Filter.new({ :location => 'a cheap motel' })

    # Run filter
    result = filter.run('<%= "I was hiding in #{location}." %>')
    assert_equal('I was hiding in a cheap motel.', result)
  end

  def test_filter_error
    # Create filter
    filter = ::Nanoc::Erubis::Filter.new

    # Run filter
    raised = false
    begin
      filter.run('<%= this isn\'t really ruby so it\'ll break, muahaha %>')
    rescue SyntaxError => e
      e.message =~ /(.+?):\d+: /
      assert_match '?', $1
      raised = true
    end
    assert raised
  end

  def test_filter_with_yield
    # Create filter
    filter = ::Nanoc::Erubis::Filter.new({ :content => 'a cheap motel' })

    # Run filter
    result = filter.run('<%= "I was hiding in #{yield}." %>')
    assert_equal('I was hiding in a cheap motel.', result)
  end

  def test_filter_with_yield_without_content
    # Create filter
    filter = ::Nanoc::Erubis::Filter.new({ :location => 'a cheap motel' })

    # Run filter
    assert_raises LocalJumpError do
      filter.run('<%= "I was hiding in #{yield}." %>')
    end
  end

  def test_filter_with_erbout
    filter = ::Nanoc::Erubis::Filter.new
    result = filter.run('stuff<% _erbout << _erbout %>')
    assert_equal 'stuffstuff', result
  end

end
