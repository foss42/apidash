# API Testing Suite Documentation

## Project Structure

```
lib/
├── src/
│   ├── workflow_builder/     # Workflow builder UI and logic
│   ├── stress_test/         # Stress testing functionality
│   ├── fake_data_provider/  # Fake data generation utilities
│   ├── lib/                 # Core source code
│   ├── tests/               # Unit and integration tests
│   └── docs/                # Documentation
└── api_testing_suite.dart   # Package entry point
```

## Workflow Builder
Contains the UI components and logic for building API workflows:
- `workflow_canvas.dart`: Main canvas widget
- `workflow_node.dart`: Individual workflow nodes
- `workflow_connection.dart`: Connection logic between nodes
- `workflow_screens.dart`: Screen management

## Stress Test
(To be implemented)
Will contain:
- Stress test execution engine
- Performance metrics collection
- Test result logging
- Configuration management

## Fake Data Provider
(To be implemented)
Will contain:
- Data generation utilities
- Service classes for different data types
- Configuration options
- Validation utilities

## Testing
All modules should have corresponding test files in the `tests/` directory. Follow the pattern:
- `workflow_builder_test.dart`
- `stress_test_test.dart`
- `fake_data_provider_test.dart`

## Contributing
1. Follow the existing code style and patterns
2. Add tests for new features
3. Update documentation when making changes
4. Maintain separation of concerns between modules
