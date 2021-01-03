class ProblemsController < ApplicationController
    before_action :logged_in_user

    def index
        @problems = current_user.problems.all
        @problems = @problems.page(params[:page]).per(5)
        @problem = current_user.problems.new
    end

    def new
        @problem = Problem.new
    end

end
