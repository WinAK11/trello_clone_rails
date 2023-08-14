import { Controller } from "@hotwired/stimulus";
import axios from "axios";
import { get, map, isNull, sample } from "lodash-es";

export default class extends Controller {
    HEADERS = { ACCEPT: "application/json" };

    getHeaders() {
        return Array.from(
            document.getElementsByClassName("kanban-board-header")
        );
    }

    getHeaderTitles() {
        return Array.from(document.querySelectorAll(".kanban-title-board"));
    }

    cursorifyHeaderTitles() {
        this.getHeaderTitles().forEach((headerTitle) => {
            headerTitle.classList.add("cursor-pointer");
        });
    }

    addLinkToHeaderTitles(boards) {
        this.getHeaderTitles().forEach((headerTitle, index) => {
            headerTitle.dataset.linkUrl = `${this.element.dataset.apiUrl}/${boards[index].id}/edit`;
            headerTitle.addEventListener("click", () => {
                Turbo.visit(
                    `${this.element.dataset.boardListsUrl}/${boards[index].id}/edit`
                );
            });
        });
    }

    buildBoardDeleteButton(boardId) {
        const button = document.createElement("button");
        button.classList.add("kanban-title-button");
        button.classList.add("btn");
        button.classList.add("btn-default");
        button.classList.add("btn-xs");
        button.classList.add("mr-2");

        button.textContent = "x";
        button.addEventListener("click", (e) => {
            e.preventDefault();

            axios
                .delete(`${this.element.dataset.boardListsUrl}/${boardId}`, {
                    headers: this.HEADERS,
                })
                .then((_) => {
                    Turbo.visit(window.location.href);
                })
                .catch((err) => {
                    console.log(err);
                });
        });
        return button;
    }

    addHeaderDeleteButtons(boards) {
        this.getHeaders().forEach((header, index) => {
            header.appendChild(this.buildBoardDeleteButton(boards[index].id));
        });
    }

    connect() {
        axios
            .get(this.element.dataset.apiUrl, { headers: this.HEADERS })
            .then((res) => {
                this.buildKanban(this.buildBoard(res["data"]));
                this.cursorifyHeaderTitles();
                this.addLinkToHeaderTitles(this.buildBoard(res["data"]));
                this.addHeaderDeleteButtons(this.buildBoard(res["data"]));
            });
    }

    buildClassList() {
        return `text-white, bg-blue-800`;
    }

    buildItems(items) {
        return map(items, (item) => {
            return {
                id: get(item, "id"),
                title: get(item, "attributes.title"),
                class: this.buildClassList(),
                "list-id": get(item, "attributes.list_id"),
            };
        });
    }

    buildBoard(boardsData) {
        return map(boardsData["data"], (board) => {
            return {
                id: get(board, "id"),
                title: get(board, "attributes.title"),
                class: this.buildClassList(get(board, "attributes.class_list")),
                item: this.buildItems(get(board, "attributes.items.data")),
            };
        });
    }

    updateListPosition(el) {
        axios
            .put(
                `${this.element.dataset.listPositionsApiUrl}/${el.dataset.id}`,
                {
                    position: el.dataset.order - 1,
                },
                {
                    headers: this.HEADERS,
                }
            )
            .then((res) => {});
    }

    buildItemData(items) {
        return map(items, (item) => {
            return {
                id: item.dataset.eid,
                position: item.dataset.position,
                list_id: item.dataset.listId,
            };
        });
    }

    itemPositioningApiCall(itemsData) {
        axios
            .put(
                this.element.dataset.itemPositionsApiUrl,
                {
                    items: itemsData,
                },
                {
                    headers: this.HEADERS,
                }
            )
            .then((res) => {});
    }

    updateItemPositioning(target, source) {
        const targetItems = Array.from(
            target.getElementsByClassName("kanban-item")
        );
        const sourceItems = Array.from(
            source.getElementsByClassName("kanban-item")
        );

        targetItems.forEach((item, index) => {
            item.dataset.position = index;
            item.dataset.listId = target.closest(".kanban-board").dataset.id;
        });
        sourceItems.forEach((item, index) => {
            item.dataset.position = index;
            item.dataset.listId = source.closest(".kanban-board").dataset.id;
        });

        const targetItemsData = this.buildItemData(targetItems);
        const sourceItemsData = this.buildItemData(sourceItems);

        this.itemPositioningApiCall(targetItemsData);
        this.itemPositioningApiCall(sourceItemsData);
    }

    showItemModal() {
        document.getElementById("show-modal-div").click();
    }

    populateItemInformation(el) {
        axios
            .get(
                `/api/items/${el.dataset.eid}`,
                {},
                {
                    headers: this.HEADERS,
                }
            )
            .then((res) => {
                console.log(res);
                document.getElementById("item-title").textContent = get(
                    res,
                    "data.data.attributes.title"
                );
                document.getElementById("item-description").textContent = get(
                    res,
                    "data.data.attributes.description"
                );
                document.getElementById("item-edit-link").href = `/lists/${get(
                    res,
                    "data.data.attributes.list_id"
                )}/items/${el.dataset.eid}/edit`;

                document
                    .getElementById("item-delete-link")
                    .addEventListener("click", (e) => {
                        e.preventDefault();
                        axios
                            .delete(
                                `/lists/${get(
                                    res,
                                    "data.data.attributes.list_id"
                                )}/items/${el.dataset.eid}`,
                                {
                                    headers: this.HEADERS,
                                }
                            )
                            .then((_) => {
                                Turbo.visit(window.location.href);
                            })
                            .catch((err) => {
                                console.log(err);
                            });
                    });

                document.getElementById(
                    "item-assign-member-link"
                ).href = `/items/${get(res, "data.data.id")}/item_members/new`;

                const membersList = map(
                    get(res, "data.data.attributes.members.data"),
                    (memberData) => {
                        const listItem = document.createElement("li");
                        listItem.textContent = memberData.attributes.email;
                        return listItem;
                    }
                );

                document.getElementById("item-members-list").innerHTML = null;
                membersList.forEach((member) => {
                    document
                        .getElementById("item-members-list")
                        .appendChild(member);
                });
            })
            .catch((err) => {
                console.log(err);
            });
    }

    buildKanban(boards) {
        new jKanban({
            element: `#${this.element.id}`,
            widthBoard: "235px",
            boards: boards,
            itemAddOptions: {
                enabled: true,
            },
            click: (el) => {
                this.showItemModal();
                this.populateItemInformation(el);
            },
            dragendBoard: (el) => {
                this.updateListPosition(el);
            },
            buttonClick: (el, boardId) => {
                Turbo.visit(`/lists/${boardId}/items/new`);
            },

            dragendEl: (el) => {},
            dropEl: (el, target, source, sibling) => {
                this.updateItemPositioning(target, source);
            },
        });
    }
}
