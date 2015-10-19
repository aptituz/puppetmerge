require 'spec_helper'

describe 'PuppetMerge::Configuration' do
  subject { PuppetMerge::Configuration.new }

  it 'responds nil to unknown configuration options' do
    expect(subject.foobar).to be(nil)
  end

  it 'adds methods for new settings' do
    subject.newmeth = 'bar'
    expect(subject).to respond_to('newmeth')
  end

  it 'is able to set and access options' do
    subject.option = 'bar'
    expect(subject.option).to eq('bar')
  end

  it 'is able to set sane defaults' do
    subject.defaults

    expect(subject.settings).to eq( {
      'source' => '.',
      'target' => '.',
      'copy_new' => false,
      'debug' => false,
      'flags' => {},
      'diff_args' => ['-Nwu']
      })
  end


end
