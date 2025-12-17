package com.roombooking.util;

import java.util.List;

public class Page<T> {

    private List<T> content;
    private int currentPage;
    private int totalPages;
    private int itemsPerPage;
    private int totalItems;
    private boolean hasNext;
    private boolean hasPrevious;

    private Page(List<T> items, int currentPage, int itemsPerPage) {
        this.totalItems = items.size();
        this.itemsPerPage = itemsPerPage;
        this.currentPage = currentPage;
        this.totalPages = calculateTotalPages(totalItems, itemsPerPage);
        this.content = extractPage(items, currentPage, itemsPerPage);
        this.hasNext = currentPage < totalPages;
        this.hasPrevious = currentPage > 1;
    }

    public static <T> Page<T> of(List<T> items, int currentPage, int itemsPerPage) {
        int validPage = Math.max(1, currentPage);
        int totalPages = calculateTotalPages(items.size(), itemsPerPage);

        if (items.isEmpty() || totalPages == 0) {
            validPage = 1;
        } else {
            validPage = Math.min(validPage, totalPages);
        }

        return new Page<>(items, validPage, itemsPerPage);
    }

    private static int calculateTotalPages(int totalItems, int itemsPerPage) {
        if (totalItems == 0 || itemsPerPage <= 0) {
            return 1;
        }
        return (totalItems + itemsPerPage - 1) / itemsPerPage;
    }

    private static <T> List<T> extractPage(List<T> items, int currentPage, int itemsPerPage) {
        int startIdx = (currentPage - 1) * itemsPerPage;
        int endIdx = Math.min(startIdx + itemsPerPage, items.size());

        if (startIdx >= items.size()) {
            return List.of();
        }

        return items.subList(startIdx, endIdx);
    }

    // ==================== GETTERS ====================
    public List<T> getContent() { return content; }
    public int getCurrentPage() { return currentPage; }
    public int getTotalPages() { return totalPages; }
    public int getItemsPerPage() { return itemsPerPage; }
    public int getTotalItems() { return totalItems; }
    public boolean isHasNext() { return hasNext; }
    public boolean isHasPrevious() { return hasPrevious; }

    // ✅ IMPORTANT: Pour JSP ${page.empty}
    public boolean hasNext() { return hasNext; }
    public boolean hasPrevious() { return hasPrevious; }

    // ==================== HELPERS ====================

    /**
     * ✅ JSP utilise ${page.empty} ou ${empty page.content}
     */
    public boolean isEmpty() {
        return content.isEmpty();
    }

    public int getPageSize() {
        return content.size();
    }

    public boolean isFirstPage() {
        return currentPage == 1;
    }

    public boolean isLastPage() {
        return currentPage == totalPages;
    }

    public int getFirstItemNumber() {
        if (isEmpty()) return 0;
        return (currentPage - 1) * itemsPerPage + 1;
    }

    public int getLastItemNumber() {
        if (isEmpty()) return 0;
        return Math.min(currentPage * itemsPerPage, totalItems);
    }
}
