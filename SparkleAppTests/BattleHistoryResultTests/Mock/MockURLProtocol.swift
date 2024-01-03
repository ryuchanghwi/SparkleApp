import Foundation

final class MockURLProtocol: URLProtocol {
    static var stubResponseData: Data?
    static var error: Error?
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    override func startLoading() {
        if let error = MockURLProtocol.error {
        } else {
            self.client?.urlProtocol(self, didLoad: MockURLProtocol.stubResponseData ?? Data())
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {
    }
}
