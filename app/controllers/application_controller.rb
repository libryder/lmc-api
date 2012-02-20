class ApplicationController < ActionController::Base

  around_filter :check_dry_run
  
  def check_dry_run
    ActiveRecord::Base.transaction do
      yield
      raise ActiveRecord::Rollback, "dry_run specified; no changes made" if @dry_run
    end
  end
end