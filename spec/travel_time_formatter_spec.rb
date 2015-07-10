require 'travel_time_formatter'

describe TravelTimeFormatter do
  let(:result) { described_class.new(input).run }
  let(:input) { -1 }

  context "negative input" do
    it "returns nil" do
      expect(result).to eq nil
    end
  end
  context "over 90 minutes" do
    let(:input) { rand(91...150) }
    it "returns nil" do
      expect(result).to eq nil
    end
  end
  context "60 minutes" do
    let(:input) { 60 }
    it "returns '1 hour'" do
      expect(result).to eq "1 hour"
    end
  end
  context "61 minutes" do
    let(:input) { 61 }
    it "returns '1 hour and 1 minute'" do
      expect(result).to eq "1 hour and 1 minute"
    end
  end
  context "between 62 and 90 minutes" do
    let(:input) { rand(62...90) }
    it "returns '1 hour and x minutes'" do
      expect(result).to eq "1 hour and #{input-60} minutes"
    end
  end
  context "1 minute" do
    let(:input) { 1 }
    it "returns '1 minute'" do
      expect(result).to eq "1 minute"
    end
  end
  context "0 minutes" do
    let(:input) { 0 }
    it "returns '0 minutes'" do
      expect(result).to eq "0 minutes"
    end
  end
  context "between 2 and 59 minutes" do
    let(:input) { rand(2...59) }
    it "returns 'x minutes'" do
      expect(result).to eq "#{input} minutes"
    end
  end
end
