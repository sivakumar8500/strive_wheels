import * as fs from "fs";
import * as path from "path";

export class FileUtils {
  /**
   * Creates a dummy image file for upload testing if it does not already exist
   */
  static getOrCreateTestImage(fileName: string = "test-upload.png"): string {
    const assetsDir = path.resolve(__dirname, "../../data/assets");
    if (!fs.existsSync(assetsDir)) {
      fs.mkdirSync(assetsDir, { recursive: true });
    }

    const filePath = path.join(assetsDir, fileName);
    if (!fs.existsSync(filePath)) {
      // 1x1 transparent PNG base64
      const dummyPngBase64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==";
      fs.writeFileSync(filePath, Buffer.from(dummyPngBase64, "base64"));
    }
    return filePath;
  }
}
