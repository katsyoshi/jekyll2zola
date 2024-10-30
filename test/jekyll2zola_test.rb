# frozen_string_literal: true

require "test_helper"

class Jekyll2zolaTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Jekyll2zola.const_defined?(:VERSION)
    end
  end

  test "something useful" do
    assert_equal("expected", "actual")
  end
end
