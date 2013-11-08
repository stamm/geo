require 'spec_helper'

describe Point do
  describe 'Class methods' do

    subject { described_class }

    describe '#to_postgis_format' do
      it { expect(subject.to_postgis_format([[1, 2]])).to eq('2.00000000 1.00000000')}
      it { expect(subject.to_postgis_format([[1, 2], [3, 4]])).to eq('2.00000000 1.00000000,4.00000000 3.00000000')}
    end

    describe '#string2floats' do
      it { expect(subject.string2floats('')).to eq([])}
      it { expect(subject.string2floats('a')).to eq([])}
      it { expect(subject.string2floats('0')).to eq([])}
      it { expect(subject.string2floats('0,0')).to eq([])}
      it { expect(subject.string2floats('1,2')).to eq([1,2])}
      it { expect(subject.string2floats('1.1234567,2')).to eq([1.1234567,2])}
      it { expect(subject.string2floats('1,2,3,4')).to eq([1,2,3,4])}
    end

    describe '#string2points' do
      it { expect(subject.string2points('1,2')).to eq([[1,2]])}
      it { expect(subject.string2points('1,2,3,4')).to eq([[1,2],[3,4]])}
    end

    describe '#sql_polygon' do
      it { expect(subject.sql_polygon([[1, 2]])).to eq("ST_MakePolygon(ST_GeomFromText('LINESTRING(2.00000000 1.00000000)'))")}
    end
  end

end