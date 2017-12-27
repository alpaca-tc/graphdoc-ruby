# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'GraphdocRuby::VERSION' do
  it 'has a version number' do
    expect(GraphdocRuby::VERSION).not_to be nil
  end
end
