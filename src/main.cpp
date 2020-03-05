//#include <GLFW/glfw3.h>
#include <opencv2/core.hpp>
#include <opencv2/opencv.hpp>
#include <opencv2/freetype.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>
#include <string>
#include <cstring>

std::string SjistoUTF8(std::string srcSjis);

int main(int argc, char **argv)
{
#ifdef FONTS_PATH
	std::string fontlist[] = {
	FONTS_PATH "/mplus-1c-black.otf",
	}; 
#endif
//"NotoSansCJKjp-Black.otf",
//"NotoSansCJKjp-Bold.otf",
//"NotoSansCJKjp-DemiLight.otf",
//"NotoSansCJKjp-Light.otf",
//"NotoSansCJKjp-Medium.otf",
//"NotoSansCJKjp-Regular.otf",
//"NotoSansCJKjp-Thin.otf",
//"NotoSansMonoCJKjp-Bold.otf",
//"NotoSansMonoCJKjp-Regular.otf",
//"mplus-1c-black.ttf",
//"mplus-1c-bold.ttf",
//"mplus-1c-heavy.ttf",
//"mplus-1c-light.ttf",
//"mplus-1c-medium.ttf",
//"mplus-1c-regular.ttf",
//"mplus-1c-thin.ttf"

	int i;
	cv::Ptr<cv::freetype::FreeType2>ft2 = cv::freetype::createFreeType2();

	ft2->setSplitNumber(4);
	cv::Scalar col(255, 255, 255);

	cv::Mat src = cv::Mat::ones(800, 900, CV_8UC3) * 255;

	for (i = 0; i < sizeof(fontlist) / sizeof(fontlist[0]); i++) {
		ft2->loadFontData(fontlist[i], 0);

		ft2->putText(src, SjistoUTF8("これはharfbuzzのテストです"),
			cv::Point(10, 10 + i * 40), 30, col, -1, 16, false);
	}
//	cv::imwrite("a.png", src);
	cv::imshow("harfbuzzのテストです",src);
	while (cv::waitKey(100) == -1);
}

//using namespace std;
//using namespace cv;
#include <Windows.h>

std::string SjistoUTF8(std::string srcSjis) {
	//Unicodeへ変換後の文字列長を得る
	int lenghtUnicode = MultiByteToWideChar(CP_THREAD_ACP, 0, srcSjis.c_str(), (int)srcSjis.size() + 1, NULL, 0);

	//必要な分だけUnicode文字列のバッファを確保
	wchar_t* bufUnicode = new wchar_t[lenghtUnicode];

	//ShiftJISからUnicodeへ変換
	MultiByteToWideChar(CP_THREAD_ACP, 0, srcSjis.c_str(), (int)srcSjis.size() + 1, bufUnicode, lenghtUnicode);


	//UTF8へ変換後の文字列長を得る
	int lengthUTF8 = WideCharToMultiByte(CP_UTF8, 0, bufUnicode, -1, NULL, 0, NULL, NULL);

	//必要な分だけUTF8文字列のバッファを確保
	char* bufUTF8 = new char[lengthUTF8];

	//UnicodeからUTF8へ変換
	WideCharToMultiByte(CP_UTF8, 0, bufUnicode, lenghtUnicode, bufUTF8, lengthUTF8, NULL, NULL);

	std::string strUTF8(bufUTF8);

	delete[] bufUnicode;
	delete bufUTF8;

	return strUTF8;
}

std::string UTF8toSjis(std::string srcUTF8) {
	//Unicodeへ変換後の文字列長を得る
	int lenghtUnicode = MultiByteToWideChar(CP_UTF8, 0, srcUTF8.c_str(), (int)srcUTF8.size() + 1, NULL, 0);

	//必要な分だけUnicode文字列のバッファを確保
	wchar_t* bufUnicode = new wchar_t[lenghtUnicode];

	//UTF8からUnicodeへ変換
	MultiByteToWideChar(CP_UTF8, 0, srcUTF8.c_str(), (int)srcUTF8.size() + 1, bufUnicode, lenghtUnicode);

	//ShiftJISへ変換後の文字列長を得る
	int lengthSJis = WideCharToMultiByte(CP_THREAD_ACP, 0, bufUnicode, -1, NULL, 0, NULL, NULL);

	//必要な分だけShiftJIS文字列のバッファを確保
	char* bufShiftJis = new char[lengthSJis];

	//UnicodeからShiftJISへ変換
	WideCharToMultiByte(CP_THREAD_ACP, 0, bufUnicode, lenghtUnicode + 1, bufShiftJis, lengthSJis, NULL, NULL);

	std::string strSJis(bufShiftJis);

	delete[] bufUnicode;
	delete bufShiftJis;

	return strSJis;
}

