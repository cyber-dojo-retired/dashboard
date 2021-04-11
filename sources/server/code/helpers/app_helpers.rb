# frozen_string_literal: true
require_relative 'gatherer'
require_relative 'animals_progress'
require_relative '../models/group'
require_relative '../models/katas'

module AppHelpers

  def group
    @group ||= Group.new(externals, params)
  end

  def katas
    @katas ||= Katas.new(externals, params)
  end

  def time
    externals.time
  end

end
