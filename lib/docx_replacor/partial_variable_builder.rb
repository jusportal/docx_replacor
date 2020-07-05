require "active_support/all"

module DocxReplacor
  class PartialVariableBuilder
    attr_reader :build_state
    attr_accessor :head_index, :head_range, :full_variable, :members

    def initialize(var_values, variable_names)
      @var_values = var_values
      @variable_names = variable_names
      reset
    end

    def reset
      @head_index = 0
      @head_range = 0..0
      @full_variable = ""
      @members = []
    end

    def activate!
      @build_state = true
      reset
    end

    def deactivate!
      @build_state = false
    end

    def in_build_state?
      @build_state
    end

    def set_head(partial_variable)
      activate!
      @head_range = partial_variable.target_range
      @head_index = partial_variable.index
      @full_variable = partial_variable.var
    end

    def set_body(partial_variable)
      @full_variable += partial_variable.var
      @members.push({ index: partial_variable.index, range: partial_variable.target_range})
    end

    def set_tail(partial_variable)
      deactivate!
      @full_variable += partial_variable.var
      @members.push({ index: partial_variable.index, range: partial_variable.target_range})
    end

    def replacement_instructions
      instructions = []
      if @full_variable.in?(@variable_names)
        instructions.push([@head_index, @head_range, @var_values[@full_variable]])
        @members.each do |member|
          instructions.push([member[:index], member[:range], ""])
        end
      end

      instructions
    end
  end
end