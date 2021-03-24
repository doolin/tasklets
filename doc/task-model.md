# Task model

Operating on and persisting a tree structure

## Updating the structure

![Swapping children](images/swap_children.drawio.svg)

Note that collection proxies do not provide a "temp" variable for the swap.
Values have to be extracted from the database. Otherwise as the end of the
update, one node will have all the children.
## Deleting and reassigning children

When a node with children is deleted, something has to be done
with the children to prevent them from being orphaned.

In one case, the deleted node's children can be assigned
to its parent node:

1. Aquire the children of the node to be deleted.
2. Reassign the parent_id for those children.
3. Delete the node.

Questions to answer: are there any Rails-specific caveats?