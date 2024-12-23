import numpy as np

def im2col(input_data, filter_h, filter_w, stride=1, pad=0):
    """
    input_data: 4D 배열 (배치 크기, 채널 수, 높이, 너비)
    filter_h: 필터의 높이
    filter_w: 필터의 너비
    stride: 스트라이드
    pad: 패딩

    Returns:
    cols: 2D 배열 (행렬로 변환된 이미지 데이터)
    """
    # 입력 데이터 크기
    N, C, H, W = input_data.shape

    # 입력 데이터 패딩
    padded_input = np.pad(input_data, 
                          ((0, 0), (0, 0), (pad, pad), (pad, pad)), 
                          mode='constant')

    # 출력 크기 계산
    out_h = (H + 2 * pad - filter_h) // stride + 1
    out_w = (W + 2 * pad - filter_w) // stride + 1

    # col 초기화
    cols = np.zeros((N, C, filter_h, filter_w, out_h, out_w))

    print("shape of init col: ", cols.shape)

    # 슬라이딩 윈도우로 데이터 채우기
    for y in range(filter_h):
        y_max = y + stride * out_h
        for x in range(filter_w):
            x_max = x + stride * out_w
            cols[:, :, y, x, :, :] = padded_input[:, :, y:y_max:stride, x:x_max:stride]

    # 행렬 형태로 변환
    cols = cols.transpose(0, 4, 5, 1, 2, 3).reshape(N * out_h * out_w, -1)

    print("transposed cols: ", cols.shape)

    return cols
import numpy as np

def im2col(input_data, filter_h, filter_w, stride=1, pad=0):
    """
    input_data: 4D 배열 (배치 크기, 채널 수, 높이, 너비)
    filter_h: 필터의 높이
    filter_w: 필터의 너비
    stride: 스트라이드
    pad: 패딩

    Returns:
    cols: 2D 배열 (행렬로 변환된 이미지 데이터)
    """
    # 입력 데이터 크기
    N, C, H, W = input_data.shape

    print("input data shape: ", input_data.shape)

    # 입력 데이터 패딩
    padded_input = np.pad(input_data, 
                          ((0, 0), (0, 0), (pad, pad), (pad, pad)), 
                          mode='constant')

    # 출력 크기 계산
    out_h = (H + 2 * pad - filter_h) // stride + 1
    out_w = (W + 2 * pad - filter_w) // stride + 1

    # col 초기화
    cols = np.zeros((N, C, filter_h, filter_w, out_h, out_w))

    print("cols shape: ", cols.shape)

    # 슬라이딩 윈도우로 데이터 채우기
    for y in range(filter_h):
        y_max = y + stride * out_h
        for x in range(filter_w):
            x_max = x + stride * out_w
            cols[:, :, y, x, :, :] = padded_input[:, :, y:y_max:stride, x:x_max:stride]

    print("slided window")
    print(cols)
    print("--")

    # 행렬 형태로 변환
    cols = cols.transpose(0, 4, 5, 1, 2, 3).reshape(N * out_h * out_w, -1)

    print("transposed cols: ", cols.shape)
    return cols

# 예제 실행
if __name__ == "__main__":
    # 샘플 입력 데이터 (1, 3, 4, 4)
    input_data = np.array([[[[1, 2, 3, 4],
                             [5, 6, 7, 8],
                             [9, 10, 11, 12],
                             [13, 14, 15, 16]],
                            [[17, 18, 19, 20],
                             [21, 22, 23, 24],
                             [25, 26, 27, 28],
                             [29, 30, 31, 32]],
                            [[33, 34, 35, 36],
                             [37, 38, 39, 40],
                             [41, 42, 43, 44],
                             [45, 46, 47, 48]]]])

    filter_h, filter_w = 2, 2  # 필터 크기
    stride, pad = 1, 0  # 스트라이드와 패딩

    result = im2col(input_data, filter_h, filter_w, stride, pad)
    print("im2col 결과:\n", result)