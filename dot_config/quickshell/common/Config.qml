pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string filePath: Directories.shellConfigPath
    property alias options: configOptionsJsonAdapter
    property bool ready: false

    FileView {
        path: root.filePath
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        onLoaded: root.ready = true
        onLoadFailed: error => {
            if (error === FileViewError.FileNotFound) {
                writeAdapter();
            }
        }

        JsonAdapter {
            id: configOptionsJsonAdapter
            property JsonObject policies: JsonObject {
                property int ai: 1
            }

            property JsonObject ai: JsonObject {
                property string systemPrompt: "## Style\n- Use casual tone, don't be formal! Make sure you answer precisely without hallucination and prefer bullet points over walls of text. You can have a friendly greeting at the beginning of the conversation, but don't repeat the user's question\n\n## Context (ignore when irrelevant)\n- You are a helpful and inspiring sidebar assistant on a {DISTRO} Linux system\n- Desktop environment: {DE}\n- Current date & time: {DATETIME}\n- Focused app: {WINDOWCLASS}\n\n## Presentation\n- Use Markdown features in your response: \n  - **Bold** text to **highlight keywords** in your response\n  - **Split long information into small sections** with h2 headers and a relevant emoji at the start of it (for example `## 🐧 Linux`). Bullet points are preferred over long paragraphs, unless you're offering writing support or instructed otherwise by the user.\n- Asked to compare different options? You should firstly use a table to compare the main aspects, then elaborate or include relevant comments from online forums *after* the table. Make sure to provide a final recommendation for the user's use case!\n- Use LaTeX formatting for mathematical and scientific notations whenever appropriate. Enclose all LaTeX '$$' delimiters. NEVER generate LaTeX code in a latex block unless the user explicitly asks for it. DO NOT use LaTeX for regular documents (resumes, letters, essays, CVs, etc.).\n"
                property string tool: "functions"
                property list<var> extraModels: [
                    {
                        "api_format": "openai",
                        "description": "This is a custom model. Edit the config to add more! | Anyway, this is DeepSeek R1 Distill LLaMA 70B",
                        "endpoint": "https://openrouter.ai/api/v1/chat/completions",
                        "homepage": "https://openrouter.ai/deepseek/deepseek-r1-distill-llama-70b:free",
                        "icon": "spark-symbolic",
                        "key_get_link": "https://openrouter.ai/settings/keys",
                        "key_id": "openrouter",
                        "model": "deepseek/deepseek-r1-distill-llama-70b:free",
                        "name": "Custom: DS R1 Dstl. LLaMA 70B",
                        "requires_key": true
                    }
                ]
            }

            property JsonObject appearance: JsonObject {
                property int fakeScreenRounding: 2 // 0: None | 1: Always | 2: When not fullscreen
            }

            property JsonObject bar: JsonObject {
                property JsonObject autoHide: JsonObject {
                    property bool enable: false
                    property int hoverRegionWidth: 4
                    property bool pushWindows: false
                    property JsonObject showWhenPressingSuper: JsonObject {
                        property bool enable: true
                        property int delay: 140
                    }
                }
                property bool bottom: false
                property int cornerStyle: 0
                property bool borderless: false
                property bool showBackground: true
                property bool verbose: true
                property bool vertical: false
                property list<string> screenList: []
                property JsonObject workspaces: JsonObject {
                    property bool monochromeIcons: true
                    property int shown: 10
                    property bool showAppIcons: true
                    property bool alwaysShowNumbers: false
                    property int showNumberDelay: 300
                    property list<string> numberMap: ["1", "2"]
                    property bool useNerdFont: false
                    property var workspacesPerMonitor: {
                        "DP-1": [1, 2, 3, 4],
                        "DP-2": [5, 6, 7],
                        "HDMI-A-1": [8, 9, 10]
                    }
                }
                property JsonObject tray: JsonObject {
                    property bool monochromeIcons: true
                    property bool showItemId: false
                    property bool invertPinnedItems: true // Makes the below a whitelist for the tray and blacklist for the pinned area
                    property list<string> pinnedItems: [ ]
                }
            }

            property JsonObject osd: JsonObject {
                property int timeout: 1000
            }

            property JsonObject interactions: JsonObject {
                property JsonObject deadPixelWorkaround: JsonObject {
                    property bool enable: false
                }
            }

            property JsonObject time: JsonObject {
                // https://doc.qt.io/qt-6/qtime.html#toString
                property string format: "hh:mm"
                property string shortDateFormat: "dd/MM"
                property string dateFormat: "ddd, dd/MM"
                property JsonObject pomodoro: JsonObject {
                    property string alertSound: ""
                    property int breakTime: 300
                    property int cyclesBeforeLongBreak: 4
                    property int focus: 1500
                    property int longBreak: 900
                }
            }

            property JsonObject audio: JsonObject {
                // Values in %
                property JsonObject protection: JsonObject {
                    // Prevent sudden bangs
                    property bool enable: false
                    property real maxAllowedIncrease: 10
                    property real maxAllowed: 99
                }
            }
        }
    }
}
