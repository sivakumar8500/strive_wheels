import Image from "next/image";
import Link from "next/link";

export function ImageLogo() {
  return (
    <Link href="/" className="flex items-center gap-2">
      <Image
        src="/logo.png"
        alt="Logo"
        width={150}
        height={40}
        priority
        className="h-8 w-auto object-contain"
      />
    </Link>
  );
}
