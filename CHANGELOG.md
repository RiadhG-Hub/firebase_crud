## 0.0.1

### Features
- **CRUD Operations**: Complete Create, Read, Update, Delete operations with `CrudRepository` mixin
- **Real-time Firestore Integration**: Seamless integration with Firebase Firestore
- **Comprehensive Error Handling**: Enhanced error logging with Firebase exception details
- **Optional Logging**: Configurable logging with multiple log levels
- **Testing Support**: Built-in support for unit testing with `FakeFirebaseFirestore`
- **Type-Safe API**: Full null safety support and strong typing

### Improvements
- Fixed `FakeFirebaseFirestore` singleton initialization for consistent test data
- Added comprehensive documentation with code examples
- Improved `ExistenceException` with proper `toString()` implementation
- Enhanced `CrudRepository` with detailed parameter documentation
- Added proper library exports for clean public API
- Fixed test data mocking in unit tests
- Added extension documentation for `Log` and `Path` extensions
- Updated README with quick start guide and API reference

### Bug Fixes
- Fixed FakeFirebaseFirestore instance recreation issue in testing
- Corrected failing test due to improper mock setup
- Improved deprecation annotations for backward compatibility methods
