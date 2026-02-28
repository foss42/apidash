import 'package:postman/postman.dart';
import 'package:test/test.dart';

void main() {
  group('Postman folder hierarchy tests', () {
    test('getRequestsFromPostmanCollection preserves folder paths', () {
      // Arrange: Create a collection with nested folder structure
      final collection = PostmanCollection(
        info: Info(
          name: 'Test Collection',
          schema:
              'https://schema.getpostman.com/json/collection/v2.1.0/collection.json',
        ),
        item: [
          // Folder: Users
          Item(
            name: 'Users',
            item: [
              Item(
                name: 'Get User',
                request: Request(
                    method: 'GET',
                    url: Url(raw: 'https://api.example.com/users/1')),
              ),
              Item(
                name: 'Create User',
                request: Request(
                    method: 'POST',
                    url: Url(raw: 'https://api.example.com/users')),
              ),
            ],
          ),
          // Folder: Products with subfolder
          Item(
            name: 'Products',
            item: [
              Item(
                name: 'List Products',
                request: Request(
                    method: 'GET',
                    url: Url(raw: 'https://api.example.com/products')),
              ),
              // Subfolder: Admin
              Item(
                name: 'Admin',
                item: [
                  Item(
                    name: 'Delete Product',
                    request: Request(
                        method: 'DELETE',
                        url: Url(raw: 'https://api.example.com/products/1')),
                  ),
                ],
              ),
            ],
          ),
          // Request at root level (no folder)
          Item(
            name: 'Health Check',
            request: Request(
                method: 'GET', url: Url(raw: 'https://api.example.com/health')),
          ),
        ],
      );

      // Act
      final requests = getRequestsFromPostmanCollection(collection);

      // Assert
      expect(requests.length, 5);

      // Extract names for easier assertions
      final names = requests.map((r) => r.$1).toList();

      // Verify folder paths are preserved
      expect(names, contains('Users/Get User'));
      expect(names, contains('Users/Create User'));
      expect(names, contains('Products/List Products'));
      expect(names, contains('Products/Admin/Delete Product'));
      expect(names, contains('Health Check')); // Root level, no folder prefix
    });

    test('getRequestsFromPostmanItem handles empty folder path', () {
      final item = Item(
        name: 'Simple Request',
        request:
            Request(method: 'GET', url: Url(raw: 'https://api.example.com')),
      );

      final requests = getRequestsFromPostmanItem(item);

      expect(requests.length, 1);
      expect(requests.first.$1, 'Simple Request');
    });

    test('getRequestsFromPostmanItem handles custom folder path', () {
      final item = Item(
        name: 'Nested Request',
        request:
            Request(method: 'GET', url: Url(raw: 'https://api.example.com')),
      );

      final requests =
          getRequestsFromPostmanItem(item, folderPath: 'Parent/Child');

      expect(requests.length, 1);
      expect(requests.first.$1, 'Parent/Child/Nested Request');
    });

    test('getRequestsFromPostmanCollection handles null item name gracefully',
        () {
      final collection = PostmanCollection(
        item: [
          Item(
            name: null, // Folder with no name
            item: [
              Item(
                name: 'Request',
                request: Request(
                    method: 'GET', url: Url(raw: 'https://api.example.com')),
              ),
            ],
          ),
        ],
      );

      final requests = getRequestsFromPostmanCollection(collection);

      expect(requests.length, 1);
      // When folder name is null, it should not add path separator
      expect(requests.first.$1, 'Request');
    });
  });
}
