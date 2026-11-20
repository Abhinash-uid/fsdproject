package com.studentreport.servlet;

import com.studentreport.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/report")
public class StudentReportServlet extends HttpServlet {
    private static String esc(String value) {
        return value == null ? "" : value.replace("&", "&amp;").replace("<", "&lt;")
                .replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            try {
                String roll = request.getParameter("rollNo");
                String name = request.getParameter("name");
                int[] marks = new int[5];
                for (int i = 0; i < marks.length; i++) {
                    marks[i] = Integer.parseInt(request.getParameter("m" + i));
                }
                int totalClasses = Integer.parseInt(request.getParameter("totalClasses"));
                int attended = Integer.parseInt(request.getParameter("attended"));
                Student s = new Student(roll, name, marks, totalClasses, attended);
                renderReport(out, s);
            } catch (IllegalArgumentException ex) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                renderError(out, ex.getMessage() == null ? "Please enter valid values." : ex.getMessage());
            }
        }
    }

    private void renderReport(PrintWriter out, Student s) {
        out.println("<!doctype html><html lang='en'><head><meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1'><title>Student Report</title>");
        out.println("<link rel='stylesheet' href='css/style.css'></head><body><main class='card result'>");
        out.println("<p class='eyebrow'>ACADEMIC SUMMARY</p><h1>Student Performance Report</h1>");
        out.println("<p><strong>Roll number:</strong> " + esc(s.getRollNo()) +
                " &nbsp; <strong>Name:</strong> " + esc(s.getName()) + "</p>");
        out.println("<div class='table-wrap'><table><thead><tr><th>Subject</th><th>Marks</th><th>Status</th></tr></thead><tbody>");
        int[] marks = s.getMarks();
        for (int i = 0; i < marks.length; i++) {
            out.println("<tr><td>" + Student.SUBJECTS[i] + "</td><td>" + marks[i] +
                    " / 100</td><td>" + (marks[i] >= 40 ? "Pass" : "Fail") + "</td></tr>");
        }
        out.println("</tbody></table></div><section class='metrics'>");
        metric(out, "Total", s.getTotal() + " / 500");
        metric(out, "Average", String.format("%.2f", s.getAverage()));
        metric(out, "Grade", s.getGrade());
        metric(out, "Attendance", String.format("%.2f%%", s.getAttendancePercentage()));
        metric(out, "Eligibility", s.isEligible() ? "Eligible" : "Not eligible");
        metric(out, "Final result", s.getFinalResult());
        out.println("</section><p class='status " + (s.getFinalResult().equals("PASS") ? "pass" : "fail") +
                "'>" + s.getFinalResult() + "</p><a class='button secondary' href='index.html'>New report</a>");
        out.println("</main></body></html>");
    }

    private void metric(PrintWriter out, String label, String value) {
        out.println("<div class='metric'><span>" + label + "</span><strong>" + value + "</strong></div>");
    }

    private void renderError(PrintWriter out, String message) {
        out.println("<!doctype html><html lang='en'><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1'>");
        out.println("<title>Input error</title><link rel='stylesheet' href='css/style.css'></head><body><main class='card result'>");
        out.println("<h1>Check your input</h1><p class='error'>" + esc(message) + "</p>");
        out.println("<a class='button' href='index.html'>Go back</a></main></body></html>");
    }
}
