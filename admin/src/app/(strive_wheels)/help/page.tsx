import { DashboardHeader } from "@/components/shared/DashboardHeader";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { HelpCircle, Mail, BookOpen, MessageCircle } from "lucide-react";
import { Button } from "@/components/ui/button";

export default function HelpPage() {
  return (
    <div className="flex flex-col gap-6 p-8">
      <DashboardHeader
        title="Help & Support"
        description="Find answers, contact support, and learn how to use the platform."
      />

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-4">
        <Card>
          <CardHeader className="pb-4">
            <div className="h-10 w-10 bg-primary/10 text-primary rounded-xl flex items-center justify-center mb-4">
              <BookOpen className="h-5 w-5" />
            </div>
            <CardTitle>Documentation</CardTitle>
            <CardDescription>
              Browse our detailed guides and tutorials to master every feature.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Button variant="outline" className="w-full">
              Read Docs
            </Button>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-4">
            <div className="h-10 w-10 bg-primary/10 text-primary rounded-xl flex items-center justify-center mb-4">
              <MessageCircle className="h-5 w-5" />
            </div>
            <CardTitle>Community Forum</CardTitle>
            <CardDescription>
              Join the conversation, ask questions, and share tips with other
              users.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Button variant="outline" className="w-full">
              Visit Forum
            </Button>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-4">
            <div className="h-10 w-10 bg-primary/10 text-primary rounded-xl flex items-center justify-center mb-4">
              <Mail className="h-5 w-5" />
            </div>
            <CardTitle>Contact Support</CardTitle>
            <CardDescription>
              Need personalized help? Reach out to our dedicated support team
              directly.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <Button className="w-full">Email Support</Button>
          </CardContent>
        </Card>
      </div>

      <div className="mt-8 rounded-xl bg-slate-50 border border-slate-100 p-8 flex flex-col items-center justify-center text-center">
        <div className="h-16 w-16 bg-white rounded-full flex items-center justify-center shadow-sm mb-4">
          <HelpCircle className="h-8 w-8 text-slate-400" />
        </div>
        <h2 className="text-xl font-semibold mb-2">
          Still can&apos;t find what you&apos;re looking for?
        </h2>
        <p className="text-slate-500 mb-6 max-w-md">
          Our support team is available Monday through Friday to assist you with
          any technical issues or billing questions.
        </p>
        <Button size="lg">Open a Support Ticket</Button>
      </div>
    </div>
  );
}
