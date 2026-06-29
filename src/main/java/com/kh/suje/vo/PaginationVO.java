package com.kh.suje.vo;

import lombok.Getter;

@Getter
public class PaginationVO {
    private int page;
    private int size;
    private int totalCount;
    private int totalPage;
    private int paginationSize;
    private int startPage;
    private int endPage;
    private int offset;

    public PaginationVO(Integer page, Integer size, int totalCount) {
        this.page = page == null || page < 1 ? 1 : page;
        this.size = size == null || size < 1 ? 10 : size;
        this.totalCount = totalCount;
        this.paginationSize = 5;

        this.totalPage = (int) Math.ceil((double) totalCount / this.size);

        if (this.totalPage > 0 && this.page > this.totalPage) {
            this.page = this.totalPage;
        }

        this.offset = (this.page - 1) * this.size;

        this.startPage = ((this.page - 1) / this.paginationSize) * this.paginationSize + 1;
        this.endPage = Math.min(this.startPage + this.paginationSize - 1, this.totalPage);
    }

    public boolean isHasPrev() {
        return page > 1;
    }

    public boolean isHasNext() {
        return page < totalPage;
    }

    public int getPrevPage() {
        return page - 1;
    }

    public int getNextPage() {
        return page + 1;
    }
}