class MemosController < ApplicationController
  def index
    @memos = Memo.all
  end

  def show
  end

  def edit
  end

  def destroy
  end

end
