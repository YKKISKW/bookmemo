class MemosController < ApplicationController
  def index
    @memos = Memo.all
  end
end
