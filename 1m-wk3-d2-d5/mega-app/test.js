import http from 'k6/http';
import { sleep, check } from 'k6';

// Options for the test run
export let options = {
  stages: [
    { duration: '1m', target: 10 }, // Ramp-up to 10 users over 1 minute
    { duration: '5m', target: 50 }, // Stay at 50 users for 5 minutes
    { duration: '1m', target: 0 },  // Ramp-down to 0 users over 1 minute
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests should be below 500ms
  },
};

// Entry point for the test
export default function () {
  let response = http.get('http://mega-app:8080/color');

  // Perform checks on the response
  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 400ms': (r) => r.timings.duration < 400,
  });

  // Simulate user wait time
  sleep(1);
}
