import http from 'k6/http';

export default function() {
  let response = http.get('http://web/');
  check(res, {
    'status was 200': r => r.status == 200,
    'トランザクション time OK': r => r.timings.duration < 200,
  });
};
