## SNRFetchedResultsController: Automatic Core Data change tracking for OS X

`SNRFetchedResultsController` is a "port" (not exactly) of `NSFetchedResultsController` from iOS to OS X. It is not a drop in replacement for `NSFetchedResultsController`, but performs many of the same tasks in relation to managing results from a Core Data fetch and notifying a delegate when objects are inserted, deleted, updated, or moved in order to update the UI. 

**This project is in its early stages and probably has a few (many?) bugs. Any feedback, bug reports, and code contributions are greatly appreciated.**

## NSFetchedResultsController vs. SNRFetchedResultsController

### Limitations

- `SNRFetchedResultsController` does not support sections or caching, mainly because (unlike `UITableView`) `NSTableView` does not support sections. That said, `SNRFetchedResultsController` can be used with custom UI controls that do support sectioning, so this would be a nice feature to add in the future.

### Differences

- As a result of having no section support, `SNRFetchedResultsController` uses indexes (`NSUInteger`) instead of `NSIndexPath`

## ARC

This project was written assuming that the code would be compiled under ARC. This means that there is no memory management code present, so if you are going to use this class in a non-ARC project then the correct retain/release calls will have to be inserted manually OR you will have to compile `SNRFetchedResultsController.m` with the `-fobjc-arc` flag.

## Example Usage

### Creating a fetched results controller

````
NSFetchRequest *request = [[NSFetchRequest alloc] init];
request.entity = [NSEntityDescription entityForName:@"Car" inManagedObjectContext:context];
request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"year" ascending:YES], nil];
request.predicate = [NSPredicate predicateWithFormat:@"wheels.@count != 0"];
request.fetchBatchSize = 20;
self.fetchedResultsController = [[SNRFetchedResultsController alloc] initWithManagedObjectContext:context fetchRequest:request];
self.fetchedResultsController.delegate = self;
NSError *error = nil;
[self.fetchedResultsController performFetch:&error];
if (error) {
    NSLog(@"Unresolved error: %@ %@", error, [error userInfo]);
}
````

### NSTableViewDataSource implementation

````
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [self.fetchedResultsController count];
}
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    return [self.fetchedResultsController objectAtIndex:rowIndex];
}
````

### SNRFetchedResultsControllerDelegate implementation for NSTableView

````
- (void)controller:(SNRFetchedResultsController *)controller didChangeObject:(id)anObject atIndex:(NSUInteger)index forChangeType:(SNRFetchedResultsChangeType)type newIndex:(NSUInteger)newIndex
{
    switch (type) {
        case SNRFetchedResultsChangeDelete:
            [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationSlideLeft];
            break;
        case SNRFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newIndex] withAnimation:NSTableViewAnimationSlideDown];
            break;
        case SNRFetchedResultsChangeUpdate:
            [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
            break;
        case SNRFetchedResultsChangeMove:
            [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:index] withAnimation:NSTableViewAnimationSlideLeft];
            [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newIndex] withAnimation:NSTableViewAnimationSlideDown];
            break;
        default:
            break;
    }
}
````

## Who am I?

I'm Indragie Karunaratne, a 17 year old Mac OS X and iOS Developer from Edmonton AB, Canada. Visit [my website](http://indragie.com) to check out my work, or to get in touch with me. ([follow me](http://twitter.com/indragie) on Twitter!)

## Licensing

`SNRFetchedResultsController` is licensed under the [BSD license](http://www.opensource.org/licenses/bsd-license.php).