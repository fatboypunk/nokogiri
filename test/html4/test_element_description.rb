# frozen_string_literal: true

require "helper"

module Nokogiri
  module HTML
    class TestElementDescription < Nokogiri::TestCase
      def test_fetch_nonexistent
        assert_nil(ElementDescription["foo"])
      end

      def test_fetch_element_description
        assert(desc = ElementDescription["a"])
        assert_instance_of(ElementDescription, desc)
      end

      def test_name
        assert_equal("a", ElementDescription["a"].name)
      end

      def test_implied_start_tag?
        refute_predicate(ElementDescription["a"], :implied_start_tag?)
      end

      def test_implied_end_tag?
        refute_predicate(ElementDescription["a"], :implied_end_tag?)
        assert_predicate(ElementDescription["p"], :implied_end_tag?)
      end

      def test_save_end_tag?
        refute_predicate(ElementDescription["a"], :save_end_tag?)
        assert_predicate(ElementDescription["br"], :save_end_tag?)
      end

      def test_empty?
        assert_empty(ElementDescription["br"])
        refute_empty(ElementDescription["a"])
      end

      def test_deprecated?
        assert_predicate(ElementDescription["applet"], :deprecated?)
        refute_predicate(ElementDescription["br"], :deprecated?)
      end

      def test_inline?
        assert_predicate(ElementDescription["a"], :inline?)
        refute_predicate(ElementDescription["div"], :inline?)
      end

      def test_block?
        element = ElementDescription["a"]
        assert_equal(!element.inline?, element.block?)
      end

      def test_description
        assert(ElementDescription["a"].description)
      end

      def test_subelements
        sub_elements = ElementDescription["body"].sub_elements
        if Nokogiri.uses_libxml?(">= 2.7.7")
          assert_equal(65, sub_elements.length)
        elsif Nokogiri.uses_libxml?
          assert_equal(61, sub_elements.length)
        else
          refute_empty(sub_elements)
        end
      end

      def test_default_sub_element
        assert_equal("div", ElementDescription["body"].default_sub_element)
      end

      def test_null_default_sub_element
        doc = Nokogiri::HTML("foo")
        doc.root.description.default_sub_element
      end

      def test_optional_attributes
        attrs = ElementDescription["table"].optional_attributes
        assert(attrs)
      end

      def test_deprecated_attributes
        attrs = ElementDescription["table"].deprecated_attributes
        assert(attrs)
        assert_equal(2, attrs.length)
      end

      def test_required_attributes
        attrs = ElementDescription["table"].required_attributes
        assert(attrs)
        assert_equal(0, attrs.length)
      end

      def test_inspect
        desc = ElementDescription["input"]
        assert_match(desc.name, desc.inspect)
      end

      def test_to_s
        desc = ElementDescription["input"]
        assert_match(desc.name, desc.to_s)
      end
    end
  end
end
