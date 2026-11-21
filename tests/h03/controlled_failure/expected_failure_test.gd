extends GdUnitTestSuite
## Solo se ejecuta de forma explícita por el autoensayo del runner.
func test_controlled_failure_h03() -> void:
    assert_int(1).is_equal(2)
