require "docx_replacor/partial_variable_builder"
require "docx_replacor/variable"
require "active_support/all"

module DocxReplacor
  class Parser
    def initialize(var_values, text_arrays)
      @instructions = []
      @full_variables = []
      @partial_variables = []
      @text_arrays = text_arrays
      @var_values = transform_keys(var_values.with_indifferent_access)
      @variables = @var_values.keys.map(&:to_s)
    end

    def replacement_instructions
      @text_arrays.each_with_index do |text, index|
        extract_full_variables(text, index)
        extract_partial_variables(text, index)
      end

      build_instructions_for_partial_variables
      @instructions
    end

    private

    def extract_full_variables(node_text, index)
      @full_variables = @variables & node_text.scan(/(\%{1}.*?\%{1})/).flatten
      @full_variables.each do |full_variable|
        var = new_var(index, full_variable, node_text, :full)
        @instructions.push(var.set_var_values(@var_values).replacement_instruction)
      end
    end

    def extract_partial_variables(text, index)
      head = text.scan(/^.*?(\%{1}[^\%]*?)$/).flatten.first
      tail = text.scan(/^(.*?\%{1}).*?$/).flatten.first
      full = text.scan(/(\%{1}.+?\%{1})/).flatten.first

      unless full && !(head || tail)
        @partial_variables.push(new_var(index, tail, text, :tail)) if tail.present?
        @partial_variables.push(new_var(index, head, text, :head)) if head.present?
        if tail.nil? && head.nil? && @partial_variables.last&.type.to_s.in?(["head", "body"])
          @partial_variables.push(new_var(index, text, text, :body))
        end
      end
    end

    def build_instructions_for_partial_variables
      builder = DocxReplacor::PartialVariableBuilder.new(@var_values, @variables)
      @partial_variables.each do |partial_variable|
        if partial_variable.type_is_head?
          builder.set_head(partial_variable)
        end

        if partial_variable.type_is_body? && builder.in_build_state?
          builder.set_body(partial_variable)
        end

        if partial_variable.type_is_tail? && builder.in_build_state?
          builder.set_tail(partial_variable)
          builder.replacement_instructions.each {|i| @instructions.push(i) }
        end
      end
    end

    def new_var(index, full_variable, node_text, type)
      DocxReplacor::Variable.new(index, full_variable, node_text, type)
    end

    def transform_keys(variable_hash)
      Hash[variable_hash.map{ |key, value| ["%#{key}%", value] }]
    end
  end
end