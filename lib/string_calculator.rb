require "string_calculator/version"

module StringCalculator
  def StringCalculator.add(input)
    return 0 if input.length == 0

    delimiter = StringCalculator.determineDelimiter(input)
    input = StringCalculator.removePreamble(input)

    split = StringCalculator.splitOnSeparators(input, delimiter)
    return nil if !StringCalculator.isArrayOnlyNumbers(split)
    allNumbers = split.map(&:to_i)

    StringCalculator.errorOnNegatives(allNumbers)

    allNumbers.select { |number| number <= 1000 }.reduce(:+)
  end

  private
  PREAMBLE_REGEX = /^\/\/\[.+\]\n/m
#Should this also remove the delimiter and return the new string?
  def StringCalculator.determineDelimiter(string)
    return string.split(/\[(.*?)\]/)[1] if string =~ PREAMBLE_REGEX
    return nil
  end

  def StringCalculator.removePreamble(string)
    return string.sub(PREAMBLE_REGEX, '') if string =~ PREAMBLE_REGEX
    return string
  end

  def StringCalculator.splitOnSeparators(string, separator)
    if separator == nil
      separators = [",", "\n"]
    else
      separators = [separator]
    end
    string.split(StringCalculator.separatorsToRegex(separators))
  end

  def StringCalculator.separatorsToRegex(separatorArray)
    return Regexp.new(separatorArray.map { | separator | Regexp.escape(separator) }.join('|'),  Regexp::MULTILINE)
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
