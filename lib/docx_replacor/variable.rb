module DocxReplacor
  class Variable
    attr_reader :index, :var, :node_text, :type

    def initialize(index, var, node_text, type)
      @var = var
      @type = type
      @index = index
      @node_text = node_text
      return self
    end

    def set_var_values(var_values)
      @var_values = var_values
      return self
    end

    def replacement_instruction
      [@index, target_range, value]
    end

    def value
      @var_values[@var]
    end

    def target_range
      idx = @node_text.index(@var)
      idx..(idx + @var.size - 1)
    end

    def type_is_head?
      @type == :head
    end

    def type_is_body?
      @type == :body
    end

    def type_is_tail?
      @type == :tail
    end
  end
end