require 'spec_helper'

describe PrettyTrace do
  let(:handler) { Handler.instance }
  let(:trace_point) { Handler.instance.trace_point }
  subject { described_class }
  
  describe '::enable' do
    it "enables the handler's trace point" do
      expect(trace_point).to receive :enable
      subject.enable
    end
  end

  describe '::disable' do
    it "disables the handler's trace point" do
      expect(trace_point).to receive :disable
      subject.disable
    end
  end

  describe '::trim' do
    before do 
      ENV['PRETTY_TRACE_TRIM'] = nil
    end

    it "enables trimming" do
      subject.trim
      expect(ENV['PRETTY_TRACE_TRIM']).not_to be nil
    end
  end

  describe '::no_trim' do
    before do 
      ENV['PRETTY_TRACE_TRIM'] = '1'
    end

    it "disables trimming" do
      subject.no_trim
      expect(ENV['PRETTY_TRACE_TRIM']).to be nil
    end
  end

  describe '::filter' do
    before do
      handler.options = { filter: [/default/] }
    end

    context "with an array" do
      let(:new_filter) { [/one mississippi/, /two mississippi/] }

      it "appends the array to the handler's filter" do
        subject.filter new_filter
        expect(handler.options[:filter]).to eq [/default/] + new_filter
      end
    end

    context "with a regex" do
      let(:new_filter) { /one mississippi/ }

      it "adds the regex to the handler's filter" do
        subject.filter new_filter
        expect(handler.options[:filter]).to eq [/default/, new_filter]
      end
    end
  end

end