require "docx"
require "open-uri"
require "docx_replacor/version"
require "docx_replacor/parser"

module DocxReplacor
  class Document
    attr_reader :file_buffer, :document, :text_nodes

    def initialize(file_url)
      @file_buffer = URI.open(file_url)
      @document = Docx::Document.open(@file_buffer)
      build_text_nodes
    end

    def match(target_vars)
      target_vars.select{|var| document_texts.include?(var.to_s) }
    end

    def substitute(var_values)
      @text_nodes.each_with_index do |group, index|
        instructions = DocxReplacor::Parser.new(var_values, group.map(&:text)).replacement_instructions

        instructions.each do |i|
          node = @text_nodes[index][i[0]]
          node.substitute(node.text[i[1]], i[2])
        end
      end

      build_text_nodes
      return self
    end

    def document_texts
      @document_texts ||= @text_nodes.flatten.map(&:text).join("")
    end

    private

    def build_text_nodes
      @text_nodes = []
      tables_text_nodes {|node_group| @text_nodes.push(node_group) }
      paragraphs_text_nodes {|node_group| @text_nodes.push(node_group)}
    end

    def tables_text_nodes
      @document.tables.each do |table|
        table.rows.each do |row|
          row.cells.each do |cell|
            cell.paragraphs.each do |p|
              group = []
              p.each_text_run { |text_node| group.push(text_node) }
              yield(group)
            end
          end
        end
      end
    end

    def paragraphs_text_nodes
      @document.paragraphs.each do |p|
        group = []
        p.each_text_run {|text_node| group.push(text_node) }
        yield(group)
      end
    end
  end
end