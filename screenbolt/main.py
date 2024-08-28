import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine

from screenbolt import rc_main
from screenbolt import rc_icons
from screenbolt import rc_images
from screenbolt.model import ClipTrackModel, WindowController, VideoController, VideoRecorder
from screenbolt.image_provider import FrameImageProvider


def main():
    app = QGuiApplication(sys.argv)

    # Determine the path to the icon
    if getattr(sys, 'frozen', False):
        # If running in a PyInstaller bundle
        base_path = Path(sys._MEIPASS)
    else:
        # If running in a regular Python environment
        base_path = Path(__file__).resolve().parent

    icon_path = base_path / "resources/icons/screenbolt.ico"
    app.setWindowIcon(QIcon(str(icon_path)))
    engine = QQmlApplicationEngine()

    # Image provider
    frame_provider = FrameImageProvider()
    engine.addImageProvider("frames", frame_provider)

    # Models
    clip_track_model = ClipTrackModel()
    window_controller = WindowController()
    video_controller = VideoController(frame_provider=frame_provider)
    video_recorder = VideoRecorder()

    engine.rootContext().setContextProperty("clipTrackModel", clip_track_model)
    engine.rootContext().setContextProperty("windowController", window_controller)
    engine.rootContext().setContextProperty("videoController", video_controller)
    engine.rootContext().setContextProperty("videoRecorder", video_recorder)

    qml_file = "qrc:/qml/entry/main.qml"
    engine.load(qml_file)
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())


if __name__ == "__main__":
    main()