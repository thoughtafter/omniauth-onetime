require 'test_helper'

module OmniAuth
  class OnetimeTest < Minitest::Test

    def test_that_it_has_a_version_number
      refute_nil ::OmniAuth::Onetime::VERSION
    end

    def test_default_difficulty
      assert_equal 696090215, OmniAuth::Strategies::Onetime.difficulty
    end

    def test_default_adversary
      assert_equal 1, OmniAuth::Strategies::Onetime.adversary_adjust
      assert_equal 38400, OmniAuth::Strategies::Onetime.adversary_speed
      assert_equal 18127, OmniAuth::Strategies::Onetime.adversary_ratio.to_i
      assert_equal 0.006,
        OmniAuth::Strategies::Onetime.adversary_chance.to_f.round(3)
    end

    def test_cache_requirement
      assert_raises RuntimeError do
        OmniAuth::Strategies::Onetime.new(nil)
      end
    end

  end
end
