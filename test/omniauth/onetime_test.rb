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
      assert_equal 20000, OmniAuth::Strategies::Onetime.adversary_speed
      assert_equal 34804, OmniAuth::Strategies::Onetime.adversary_ratio.to_i
      assert OmniAuth::Strategies::Onetime.adversary_chance < 0.003
    end

  end
end
