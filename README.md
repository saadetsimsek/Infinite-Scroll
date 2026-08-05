# Infinite Scroll

*Pagination that loads the next page as the list reaches its end.*

![Swift](https://img.shields.io/badge/Swift-5.0-F05138?style=flat-square&logo=swift&logoColor=white) ![UIKit](https://img.shields.io/badge/UIKit-2396F3?style=flat-square&logo=uikit&logoColor=white) ![iOS](https://img.shields.io/badge/iOS-17.4%2B-000000?style=flat-square&logo=apple&logoColor=white) ![Topic](https://img.shields.io/badge/topic-pagination-6366F1?style=flat-square) ![Package](https://img.shields.io/badge/UIScrollView----InfiniteScroll-8B5CF6?style=flat-square)

## Overview

The first page loads on appearance. When the user scrolls near the bottom the next page is requested, appended to the existing rows, and the spinner is dismissed. The trigger and the spinner come from the library, the paging state is the application's own.

## How it works

```mermaid
sequenceDiagram
    participant V as ViewController
    participant L as InfiniteScroll
    participant A as APICaller
    participant T as UITableView

    V->>A: fetchData()
    A-->>V: first page
    V->>T: reloadData()
    V->>L: addInfiniteScroll { ... }
    Note over V,L: the user scrolls towards the bottom
    L->>V: the closure fires
    V->>A: loadMorePosts()
    A-->>V: next page appended
    V->>T: reloadData()
    V->>L: finishInfiniteScroll()
```

## Implementation notes

- **finishInfiniteScroll is mandatory.** Forgetting it leaves the spinner on screen and blocks any further trigger, which is the usual bug in this pattern.
- **Append rather than replace.** `loadMorePosts` adds to the existing array so scroll position is preserved across pages.
- **Reload on the main queue.** The completion arrives on a background queue, so the dispatch back is explicit at every call site.
- **Weak self in both closures.** The controller can be dismissed while a page is in flight, and the capture list is what prevents the retain cycle.

## Project structure

```
InfiniteScroll/
├── APICaller.swift        first page and subsequent pages
└── ViewController.swift  table view and scroll trigger
```

## Requirements

Xcode 15 or later, iOS 17.4 or later, Swift Package Manager for UIScrollView-InfiniteScroll.
