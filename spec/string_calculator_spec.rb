require 'spec_helper'
require 'string_calculator'

describe StringCalculator do
  it 'has a version number' do
    expect(StringCalculator::VERSION).not_to be nil
  end

  describe 'add' do
    it 'adds 0 numbers' do
      expect(StringCalculator.add("")).to eq(0)
    end

# This actually caught a bug. Amazing!
    it 'adds 1 number' do
      (0..100).each { |number| expect(StringCalculator.add(number.to_s)).to eq(number) }
    end

    it 'adds 2 numbers' do
      (0..10).each { |number| (0..10).each { |number2| expect(StringCalculator.add(number.to_s + "," + number2.to_s)).to eq(number +  number2) } }
    end

    it 'adds many numbers' do
      expect(StringCalculator.add("1,2,3,4,5,6,7,8,9,10")).to eq(55)
    end

    it 'adds with newline delimiters' do
      expect(StringCalculator.add("1\n2\n3\n4\n5\n6\n7\n8\n9\n10")).to eq(55)
    end

    it 'adds with newline and comma delmitiers' do
      expect(StringCalculator.add("1\n2,3,4\n5,6\n7\n8,9\n10")).to eq(55)
    end

    it 'allows custom delimiters' do
      expect(StringCalculator.add("//[/]\n1/2/3/4/5/6/7/8/9/10")).to eq(55)
    end

    it 'throws an exception when passed a single negative number' do
      expect { StringCalculator.add("1,2,3,4,-5,6,7,8,9,10") }.to raise_error("Negatives are not allowed: -5")
    end

    it 'throws an exception when passed a multiple negative numbers' do
      expect { StringCalculator.add("1,-2,3,4,-5,6,7,8,-9,10") }.to raise_error("Negatives are not allowed: -2, -5, -9")
    end

    it 'ignores numbers above 1000' do
        expect(StringCalculator.add("//[/]\n1/2/3/4/5/6/7/8/9/10/10000000/102155")).to eq(55)
    end

    it 'works with a multicharacter delimiter' do
      expect(StringCalculator.add("//[///]\n1///2///3///4///5///6///7///8///9///10")).to eq(55)
    end
  end

  describe 'splitOnSeparators' do
    it 'splits on comma or \n' do
      expect(StringCalculator.splitOnSeparators("1\n2,3", nil)).to eq(["1", "2", "3"])
      expect(StringCalculator.splitOnSeparators("1\n,2,\n3", nil)).to eq(["1", "", "2", "", "3"])
    end

    it 'splits on a custom delimiter' do
      expect(StringCalculator.splitOnSeparators("1/2/3", "/")).to eq(["1", "2", "3"])
      expect(StringCalculator.splitOnSeparators("1p2p3", "p")).to eq(["1", "2", "3"])
    end
  end

  describe 'isArrayOnlyNumbers' do
    it 'returns true on valid input' do
      expect(StringCalculator.isArrayOnlyNumbers(["1", "2", "3"])).to eq(true)
    end

    it 'returns false when passed an empty value' do
      expect(StringCalculator.isArrayOnlyNumbers(["1", "", "3"])).to eq(false)
    end

    it 'returns false when passed not just digits' do
      expect(StringCalculator.isArrayOnlyNumbers(["1", "2,", "3"])).to eq(false)
    end

    it 'returns true with negative numbers' do
      expect(StringCalculator.isArrayOnlyNumbers(["1", "-2", "3"])).to eq(true)
    end
  end

  describe'determineDelimiter' do
    it 'returns single character delimiter' do
      expect(StringCalculator.determineDelimiter("//[.]\n")).to eq(".")
    end

    it 'returns multicharacter delimiter' do
      expect(StringCalculator.determineDelimiter("//[...]\n")).to eq("...")
    end

    it 'returns nil when the custom delimiter preamble is missing' do
      expect(StringCalculator.determineDelimiter("1,2,3,4,5,6,7,8,9,10")).to eq(nil)
    end
  end

  describe 'separatorsToRegex' do
    it 'converts one separator to regex' do
      expect(StringCalculator.separatorsToRegex(["\n"])).to eq(/\n/m)
    end

    it 'converts two separator to regex' do
      expect(StringCalculator.separatorsToRegex([",", "\n"])).to eq(/,|\n/m)
    end
  end

  describe 'removePreamble' do
    it 'removes the preamble when it exists' do
      expect(StringCalculator.removePreamble("//[/]\n1/2/3/4/5/6/7/8,9/10")).to eq("1/2/3/4/5/6/7/8,9/10")
    end

    it 'does nothing when the preamble is missing' do
      expect(StringCalculator.removePreamble("1/2/3/4/5/6/7/8,9/10")).to eq("1/2/3/4/5/6/7/8,9/10")
    end
  end

  describe 'errorOnNegatives' do
    it 'does not error when no negative numbers are passed' do
      expect { StringCalculator.errorOnNegatives([1,2,3,4,5,6,7,8,9,10]) }.not_to raise_error
    end

    it 'raises error when negative numbers are passed' do
      expect { StringCalculator.errorOnNegatives([1,2,-3,4,5,-6,7,8,9,-10]) }.to raise_error("Negatives are not allowed: -3, -6, -10")
    end
  end
end
