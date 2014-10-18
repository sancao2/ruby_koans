require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutClasses < Neo::Koan
  class Dog
  end

  def test_instances_of_classes_can_be_created_with_new
    fido = Dog.new
    assert_equal Dog, fido.class
  end

  # ------------------------------------------------------------------

  class Dog2
    def set_name(a_name)
      @name = a_name
    end
  end

  def test_instance_variables_can_be_set_by_assigning_to_them
    fido = Dog2.new
    assert_equal [], fido.instance_variables

    fido.set_name("Fido")
    assert_equal [:@name], fido.instance_variables
  end

  def test_instance_variables_cannot_be_accessed_outside_the_class
    fido = Dog2.new
    fido.set_name("Fido")

    assert_raise(NoMethodError) do
      fido.name
    end

    assert_raise(SyntaxError) do
      eval "fido.@name"
      # NOTE: Using eval because the above line is a syntax error.
    end
  end

  def test_you_can_politely_ask_for_instance_variable_values
    fido = Dog2.new
    fido.set_name("Fido")

    assert_equal "Fido", fido.instance_variable_get("@name")
  end

  def test_you_can_rip_the_value_out_using_instance_eval
    fido = Dog2.new
    fido.set_name("Fido")

    assert_equal "Fido", fido.instance_eval("@name")  # string version
    assert_equal "Fido", fido.instance_eval { @name } # block version
  end

  # ------------------------------------------------------------------

  class Dog3
    def set_name(a_name)
      @name = a_name
    end
    def name
      @name
    end
  end

  def test_you_can_create_accessor_methods_to_return_instance_variables
    fido = Dog3.new
    fido.set_name("Fido")

    assert_equal "Fido", fido.name
  end

  # ------------------------------------------------------------------

  class Dog4
    attr_reader :name

    def set_name(a_name)
      @name = a_name
    end
  end


  def test_attr_reader_will_automatically_define_an_accessor
    fido = Dog4.new
    fido.set_name("Fido")

    assert_equal "Fido", fido.name
  end

  # ------------------------------------------------------------------

  class Dog5
    attr_accessor :name
  end


  def test_attr_accessor_will_automatically_define_both_read_and_write_accessors
    fido = Dog5.new

    fido.name = "Fido"
    assert_equal "Fido", fido.name
  end

  # ------------------------------------------------------------------

  class Dog6
    attr_reader :name
    def initialize(initial_name)
      @name = initial_name
    end
  end

  def test_initialize_provides_initial_values_for_instance_variables
    fido = Dog6.new("Fido")
    assert_equal "Fido", fido.name
  end

  def test_args_to_new_must_match_initialize
    assert_raise(ArgumentError) do
      Dog6.new
    end
    # THINK ABOUT IT:
    # Why is this so?
  end

  def test_different_objects_have_different_instance_variables
    fido = Dog6.new("Fido")
    rover = Dog6.new("Rover")

    assert_equal true, rover.name != fido.name
  end

  # ------------------------------------------------------------------

  class Dog7
    attr_reader :name

    def initialize(initial_name)
      @name = initial_name
    end

    def get_self
      self
    end

    def to_s
      @name
    end

    def inspect
      "<Dog named '#{name}'>"
    end
  end

  def test_inside_a_method_self_refers_to_the_containing_object
    fido = Dog7.new("Fido")

    fidos_self = fido.get_self
    #assert_equal "<Dog named 'Fido'>", fidos_self
    assert_equal fido, fidos_self
  end

  def test_to_s_provides_a_string_version_of_the_object
    fido = Dog7.new("Fido")
    assert_equal "Fido", fido.to_s
  end

  def test_to_s_is_used_in_string_interpolation
    fido = Dog7.new("Fido")
    assert_equal "My dog is Fido", "My dog is #{fido}"
  end

  def test_inspect_provides_a_more_complete_string_version
    fido = Dog7.new("Fido")
    assert_equal "<Dog named 'Fido'>", fido.inspect
  end

  def test_all_objects_support_to_s_and_inspect
    array = [1,2,3]

    assert_equal "[1, 2, 3]", array.to_s
    assert_equal "[1, 2, 3]", array.inspect
    assert_equal [:inspect, :to_s, :to_a, :to_ary, :frozen?, :==, :eql?, :hash, :[], :[]=, :at, :fetch, :first, :last, :concat, :<<, :push, :pop, :shift, :unshift, :insert, :each, :each_index, :reverse_each, :length, :size, :empty?, :find_index, :index, :rindex, :join, :reverse, :reverse!, :rotate, :rotate!, :sort, :sort!, :sort_by!, :collect, :collect!, :map, :map!, :select, :select!, :keep_if, :values_at, :delete, :delete_at, :delete_if, :reject, :reject!, :zip, :transpose, :replace, :clear, :fill, :include?, :<=>, :slice, :slice!, :assoc, :rassoc, :+, :*, :-, :&, :|, :uniq, :uniq!, :compact, :compact!, :flatten, :flatten!, :count, :shuffle!, :shuffle, :sample, :cycle, :permutation, :combination, :repeated_permutation, :repeated_combination, :product, :take, :take_while, :drop, :drop_while, :pack, :entries, :sort_by, :grep, :find, :detect, :find_all, :flat_map, :collect_concat, :inject, :reduce, :partition, :group_by, :all?, :any?, :one?, :none?, :min, :max, :minmax, :min_by, :max_by, :minmax_by, :member?, :each_with_index, :each_entry, :each_slice, :each_cons, :each_with_object, :chunk, :slice_before, :____, :method_missing, :nil?, :===, :=~, :!~, :class, :singleton_class, :clone, :dup, :initialize_dup, :initialize_clone, :taint, :tainted?, :untaint, :untrust, :untrusted?, :trust, :freeze, :methods, :singleton_methods, :protected_methods, :private_methods, :public_methods, :instance_variables, :instance_variable_get, :instance_variable_set, :instance_variable_defined?, :instance_of?, :kind_of?, :is_a?, :tap, :send, :public_send, :respond_to?, :respond_to_missing?, :extend, :display, :method, :public_method, :define_singleton_method, :object_id, :to_enum, :enum_for, :equal?, :!, :!=, :instance_eval, :instance_exec, :__send__, :__id__], array.methods

    assert_equal "STRING", "STRING".to_s
    assert_equal "\"STRING\"", "STRING".inspect
    assert_equal [:<=>, :==, :===, :eql?, :hash, :casecmp, :+, :*, :%, :[], :[]=, :insert, :length, :size, :bytesize, :empty?, :=~, :match, :succ, :succ!, :next, :next!, :upto, :index, :rindex, :replace, :clear, :chr, :getbyte, :setbyte, :byteslice, :to_i, :to_f, :to_s, :to_str, :inspect, :dump, :upcase, :downcase, :capitalize, :swapcase, :upcase!, :downcase!, :capitalize!, :swapcase!, :hex, :oct, :split, :lines, :bytes, :chars, :codepoints, :reverse, :reverse!, :concat, :<<, :prepend, :crypt, :intern, :to_sym, :ord, :include?, :start_with?, :end_with?, :scan, :ljust, :rjust, :center, :sub, :gsub, :chop, :chomp, :strip, :lstrip, :rstrip, :sub!, :gsub!, :chop!, :chomp!, :strip!, :lstrip!, :rstrip!, :tr, :tr_s, :delete, :squeeze, :count, :tr!, :tr_s!, :delete!, :squeeze!, :each_line, :each_byte, :each_char, :each_codepoint, :sum, :slice, :slice!, :partition, :rpartition, :encoding, :force_encoding, :valid_encoding?, :ascii_only?, :unpack, :encode, :encode!, :to_r, :to_c, :side_padding, :>, :>=, :<, :<=, :between?, :____, :method_missing, :nil?, :!~, :class, :singleton_class, :clone, :dup, :initialize_dup, :initialize_clone, :taint, :tainted?, :untaint, :untrust, :untrusted?, :trust, :freeze, :frozen?, :methods, :singleton_methods, :protected_methods, :private_methods, :public_methods, :instance_variables, :instance_variable_get, :instance_variable_set, :instance_variable_defined?, :instance_of?, :kind_of?, :is_a?, :tap, :send, :public_send, :respond_to?, :respond_to_missing?, :extend, :display, :method, :public_method, :define_singleton_method, :object_id, :to_enum, :enum_for, :equal?, :!, :!=, :instance_eval, :instance_exec, :__send__, :__id__], "STRING".methods
  end
end
