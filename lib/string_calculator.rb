require "string_calculator/version"

module StringCalculator
  def StringCalculator.add(input)
    return 0 if input.length == 0

    delimiters = StringCalculator.determineDelimiters(input)
    input = StringCalculator.removePreamble(input)

    split = StringCalculator.splitOnDelimiters(input, delimiters)
    return nil if !StringCalculator.isArrayOnlyNumbers(split)
    allNumbers = split.map(&:to_i)

    StringCalculator.errorOnNegatives(allNumbers)

    allNumbers.select { |number| number <= 1000 }.reduce(:+)
  end

  private
  PREAMBLE_REGEX = /^\/\/\[.+\]\n/m
#Should this also remove the delimiter and return the new string?
  def StringCalculator.determineDelimiters(string)
    return string.scan(/\[(.*?)\]/).map { | delimiterArray | delimiterArray[0] } if string =~ PREAMBLE_REGEX
    return nil
  end

  def StringCalculator.removePreamble(string)
    return string.sub(PREAMBLE_REGEX, '') if string =~ PREAMBLE_REGEX
    return string
  end

  def StringCalculator.splitOnDelimiters(string, delimiters)
    if delimiters == nil
      delimiters = [",", "\n"]
    end
    string.split(StringCalculator.delimitersToRegex(delimiters))
  end

  def StringCalculator.delimitersToRegex(delimiters)
    return Regexp.new(delimiters.map { | delimiter | Regexp.escape(delimiter) }.join('|'),  Regexp::MULTILINE)
  end

  def StringCalculator.isArrayOnlyNumbers(input)
    input.reduce(true) { |valid, value| !(/^-[0-9]+|[0-9]+$/ === value) ? false : valid }
  end

  def StringCalculator.errorOnNegatives(array)
    negatives = array.select { |number| number < 0 }
    if negatives.length > 0
      raise "Negatives are not allowed: #{negatives.join(', ')}"
    end
  end
end
