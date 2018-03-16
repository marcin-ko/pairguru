class TitleBracketsValidator < ActiveModel::Validator
  def validate(record)
    chars = record.title.chars
    unclosed_round_brackets = 0
    unclosed_square_brackets = 0
    unclosed_curly_brackets = 0
    chars.each_with_index do |char, index|
      case char
      when "("
        unclosed_round_brackets += 1
        fail_if_bracket_immediately_closed(record, index + 1, ")")
      when ")"
        unclosed_round_brackets -= 1
      when "["
        unclosed_square_brackets += 1
        fail_if_bracket_immediately_closed(record, index + 1, "]")
      when "]"
        unclosed_square_brackets -= 1
      when "{"
        unclosed_curly_brackets += 1
        fail_if_bracket_immediately_closed(record, index + 1, "}")
      when "}"
        unclosed_curly_brackets -= 1
      end
      if unclosed_round_brackets < 0 || unclosed_square_brackets < 0 || unclosed_curly_brackets < 0
        record.errors[:title] << "Found right bracket without matching left bracket at #{index}"
        return
      end
    end
    unless unclosed_round_brackets + unclosed_square_brackets + unclosed_curly_brackets == 0
      record.errors[:title] << "At least one bracket is not closed"
    end
  end

  private

  def fail_if_bracket_immediately_closed(record, index, bracket)
    if record.title[index] == bracket
      record.errors[:title] << "Found right bracket right after matching left bracket at #{index}"
    end
  end
end
