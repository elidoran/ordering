0.6.0 - 2016/11/06

1. add this CHANGES file
2. add missing keywords to *package.json*
3. update to newest `needier` dep
4. catch results from calling `needier` functions and return errors when encountered
5. check for more than array existence, check their length is greater than zero
6. add more comments
7. correct bug when `before` constraint doesn't exist yet the `add()` wasn't providing an `object` as the constraint's ID so there's a placeholder to replace when the actual constraint is encountered
