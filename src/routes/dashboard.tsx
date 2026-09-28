import {
  Card,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";

export function DashboardPage() {
  return (
    <section className="space-y-8">
      <div className="max-w-2xl space-y-4">
        <p className="text-muted-foreground text-sm">
          Your personal study curriculum
        </p>
        <h1 className="text-4xl font-semibold tracking-tight sm:text-5xl">
          A little space to learn.
        </h1>
        <p className="text-muted-foreground leading-relaxed">
          Make room for your curiosity, one study season at a time.
        </p>
      </div>
      <Card className="max-w-2xl">
        <CardHeader>
          <CardTitle>Welcome to Lollipop</CardTitle>
          <CardDescription>
            Your study space is taking shape. Season planning and study tracking
            are coming soon.
          </CardDescription>
        </CardHeader>
      </Card>
    </section>
  );
}
