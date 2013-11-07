require 'spec_helper'

describe Point do
  describe 'Class methods' do

    subject { described_class }

    describe '#get_geom' do
      it { expect(subject.get_geom([[1, 2]])).to eq('2.00000000 1.00000000')}
      it { expect(subject.get_geom([[1, 2], [3, 4]])).to eq('2.00000000 1.00000000,4.00000000 3.00000000')}
    end

    describe '#parse_point' do
      it { expect(subject.parse_point('')).to eq([])}
      it { expect(subject.parse_point('a')).to eq([])}
      it { expect(subject.parse_point('0')).to eq([])}
      it { expect(subject.parse_point('0,0')).to eq([])}
      it { expect(subject.parse_point('1,2,3')).to eq([1,2,3])}
      it { expect(subject.parse_point('1.1234567,2,3')).to eq([1.1234567,2,3])}
    end
  end

end